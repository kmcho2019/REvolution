module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

// State encoding with one-hot 2-bit vector
localparam [1:0]
    STATE_A = 2'b01,
    STATE_B = 2'b10;

reg [1:0] state, next_state;

// Next state and output logic
always @(*) begin
    case (state)
        STATE_A: begin
            if (x) begin
                next_state = STATE_B;
                z = 1'b1;
            end else begin
                next_state = STATE_A;
                z = 1'b0;
            end
        end

        STATE_B: begin
            if (x) begin
                next_state = STATE_B;
                z = 1'b0;
            end else begin
                next_state = STATE_B;
                z = 1'b1;
            end
        end

        default: begin
            next_state = STATE_A;
            z = 1'b0;
        end
    endcase
end

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= STATE_A; // Reset state A
    end else begin
        state <= next_state;
    end
end

endmodule