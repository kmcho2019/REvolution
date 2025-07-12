module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output [1:0] state
);

reg [1:0] state_reg;
reg [1:0] next_state;

wire inc;
wire dec;

assign inc = train_valid && train_taken;
assign dec = train_valid &&!train_taken;

assign next_state = (inc && state_reg == 2'b11)? 2'b11 :
                    (inc)? state_reg + 1 :
                    (dec && state_reg == 2'b00)? 2'b00 :
                    (dec)? state_reg - 1 :
                    state_reg;

always @(posedge areset or posedge clk) begin
    if (areset) begin
        state_reg <= 2'b01;
    end else begin
        state_reg <= next_state;
    end
end

assign state = state_reg;

endmodule