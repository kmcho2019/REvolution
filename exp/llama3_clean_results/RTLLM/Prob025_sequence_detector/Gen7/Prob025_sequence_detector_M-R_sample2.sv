module sequence_detector(
    input           clk,
    input           reset_n,
    input           data_in,
    output          sequence_detected
);

// Define the states as parameters
localparam IDLE    = 4'b0000;
localparam S1      = 4'b0001;
localparam S2      = 4'b0010;
localparam S3      = 4'b0100;
localparam S4      = 4'b1000;

// Declare the current state
reg [3:0] current_state;

// Initial state
initial current_state = IDLE;

// Combinational logic for next state
reg [3:0] next_state;
always @(*) begin
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
            next_state = IDLE; // After detecting the sequence, return to IDLE
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for updating the current state
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign sequence_detected = (current_state == S4);

endmodule