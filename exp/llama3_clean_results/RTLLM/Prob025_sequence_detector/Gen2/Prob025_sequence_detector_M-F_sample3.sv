// Corrected Module
module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output logic    sequence_detected
);

// Define the states of the FSM
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} current_state, next_state;

// Update the current state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0; // Reset sequence_detected on reset
    end else begin
        current_state <= next_state;
    end
end

// Define the state transitions
always_comb begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3; // Corrected transition to S3
            end else begin
                next_state = IDLE;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE; // Transition back to IDLE after detection
        end
        default: next_state = IDLE;
    endcase
end

// Update the sequence_detected output
always_ff @(posedge clk) begin
    if (current_state == S4) begin
        sequence_detected <= 1'b1;
    end else begin
        sequence_detected <= 1'b0;
    end
end

endmodule

// Example Testbench (corrected)
module sequence_detector_tb;
    logic           clk;
    logic           reset_n;
    logic           data_in;
    logic           sequence_detected;

    sequence_detector uut (
       .clk(clk),
       .reset_n(reset_n),
       .data_in(data_in),
       .sequence_detected(sequence_detected)
    );

    // Clock generation
    always begin
        #5ns;
        clk = ~clk;
    end

    initial begin
        $dumpfile("sequence_detector.vcd");
        $dumpvars(0, sequence_detector_tb);
        
        clk = 0;
        reset_n = 1'b1;
        data_in = 1'b0;
        
        #10ns;
        reset_n = 1'b0; // Reset the detector
        #10ns;
        reset_n = 1'b1; // Release reset
        
        // Feed the sequence '1001'
        data_in = 1'b1; #10ns;
        data_in = 1'b0; #10ns;
        data_in = 1'b0; #10ns;
        data_in = 1'b1; #10ns;
        
        #20ns;
        $finish;
    end
endmodule