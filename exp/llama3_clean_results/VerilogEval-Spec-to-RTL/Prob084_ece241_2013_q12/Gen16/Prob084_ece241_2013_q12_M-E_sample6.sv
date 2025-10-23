module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

reg [7:0] Q;
reg [1:0] ring_counter;

always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
        ring_counter <= ring_counter + 1;
    end
end

wire [2:0] select;
assign select = {A, B, C};

reg [7:0] output;
always @(posedge clk) begin
    case (select)
        3'b000: output <= Q[0];
        3'b001: output <= Q[1];
        3'b010: output <= Q[2];
        3'b011: output <= Q[3];
        3'b100: output <= Q[4];
        3'b101: output <= Q[5];
        3'b110: output <= Q[6];
        3'b111: output <= Q[7];
    endcase
end

assign Z = output;

endmodule