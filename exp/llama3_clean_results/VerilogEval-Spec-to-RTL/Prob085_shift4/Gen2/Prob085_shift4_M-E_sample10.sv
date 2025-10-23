module TopModule (
    input           clk,
    input           areset,
    input           load,
    input           ena,
    input   [3:0]    data,
    output  [3:0]    q
);

reg [1:0] state; // FSM states: idle, load, shift
reg [3:0] q_reg;

// FSM state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to idle state
    end else begin
        case (state)
            2'b00: begin // idle state
                if (load) begin
                    state <= 2'b01; // transition to load state
                end else if (ena) begin
                    state <= 2'b10; // transition to shift state
                end
            end
            2'b01: begin // load state
                state <= 2'b00; // transition back to idle state
            end
            2'b10: begin // shift state
                state <= 2'b00; // transition back to idle state
            end
        endcase
    end
end

// control signals generation
wire load_enable;
wire shift_enable;
assign load_enable = (state == 2'b01);
assign shift_enable = (state == 2'b10);

// shift register
always @(posedge clk) begin
    if (load_enable) begin
        q_reg <= data;
    end else if (shift_enable) begin
        q_reg <= {1'b0, q_reg[3:1]};
    end
end

assign q = q_reg;

endmodule