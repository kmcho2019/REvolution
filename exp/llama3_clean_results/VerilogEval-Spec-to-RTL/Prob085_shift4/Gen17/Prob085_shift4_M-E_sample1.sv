module TopModule(
    input  clk,
    input  areset,
    input  load,
    input  ena,
    input  [3:0] data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [3:0] shift_reg;

// Reset logic
always @(posedge areset) begin
    q_reg <= 4'b0;
    shift_reg <= 4'b0;
end

// Shift logic
always @(posedge clk) begin
    if (ena) begin
        shift_reg <= {1'b0, q_reg[3:1]};
    end
end

// Load and shift/select logic
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else if (ena) begin
        q_reg <= shift_reg;
    end
end

assign q = q_reg;

endmodule