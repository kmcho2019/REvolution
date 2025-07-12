module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

// Define the outputs of the D-type flip-flops
reg [7:0] Q;

// Shift register
always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

// 3-to-8 multiplexer using 2-to-1 multiplexers
reg [7:0] data_in;
assign data_in = {Q[7], Q[6], Q[5], Q[4], Q[3], Q[2], Q[1], Q[0]};

reg [7:0] mux_out_1;
always @(*) begin
    case ({A, B})
        2'b00: mux_out_1[0] = (C)? Q[1] : Q[0];
        2'b01: mux_out_1[0] = (C)? Q[3] : Q[2];
        2'b10: mux_out_1[0] = (C)? Q[5] : Q[4];
        2'b11: mux_out_1[0] = (C)? Q[7] : Q[6];
        default: mux_out_1[0] = 1'b0;
    endcase
end

assign Z = mux_out_1[0];

endmodule