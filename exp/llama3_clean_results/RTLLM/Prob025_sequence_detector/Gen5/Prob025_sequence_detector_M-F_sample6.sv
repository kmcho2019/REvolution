module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states for the sequence detection with enough bits to uniquely represent all states
enum logic [2:0] {
    IDLE = 3'b000,
    S1   = 3'b001,
    S2   = 3'b010,
    S3   = 3'b011,
    S4   = 3'b100
} state, next_state;

// Update the state
always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always_comb begin
    next_state = state;
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
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
                next_state = S3;
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
            next_state = IDLE;
        end
    endcase
end

// Assign the sequence_detected output
assign sequence_detected = (state == S4);

endmodule

// Example testbench with corrected port name
module tb_sequence_detector;
    reg clk;
    reg reset_n;
    reg data_in;
    wire sequence_detected;

    sequence_detector uut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .sequence_detected(sequence_detected)
    );

    initial begin
        clk = 0;
        reset_n = 0;
        data_in = 0;
        #10;
        reset_n = 1;
        #10;
        data_in = 1; // Start of sequence
        #10;
        data_in = 0; // Second bit of sequence
        #10;
        data_in = 0; // Third bit of sequence
        #10;
        data_in = 1; // Fourth bit of sequence
        #10;
        $finish;
    end

    always #5 clk = ~clk;

endmodule