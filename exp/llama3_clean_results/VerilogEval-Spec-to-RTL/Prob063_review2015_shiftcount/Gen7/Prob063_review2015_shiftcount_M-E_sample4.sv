module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [1:0] state;

// State machine states
parameter IDLE = 2'b00;
parameter SHIFTING = 2'b01;
parameter COUNTING = 2'b10;

// Decrement logic
wire [3:0] dec_val;
assign dec_val = (q_reg == 4'b0000) ? 4'b1111 : q_reg - 1;

// Shift logic
wire [3:0] shift_val;
assign shift_val = {data, q_reg[3:1]};

// State machine
always @(posedge clk) begin
    case (state)
        IDLE: begin
            if (shift_ena) begin
                state <= SHIFTING;
            end else if (count_ena) begin
                state <= COUNTING;
            end
        end
        SHIFTING: begin
            q_reg <= shift_val;
            state <= IDLE;
        end
        COUNTING: begin
            q_reg <= dec_val;
            state <= IDLE;
        end
    endcase
end

// Output assignment
assign q = q_reg;

// Initialize state machine
initial begin
    state = IDLE;
    q_reg = 4'b0000;
end

endmodule