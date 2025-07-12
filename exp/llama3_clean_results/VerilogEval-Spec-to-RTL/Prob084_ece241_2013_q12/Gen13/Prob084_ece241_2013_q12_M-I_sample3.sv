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

always @(posedge clk) begin
    if (enable) begin
        Q <= {Q[6:0], S};
    end
end

always @(*) begin
    // Use a 3-to-8 decoder and 8 2-to-1 multiplexers
    // to reduce power consumption by minimizing switching activity
    reg [7:0] Q_out;
    always @(Q or {A, B, C}) begin
        case ({A, B, C})
            3'b000: Q_out = {7'b0, Q[0]};
            3'b001: Q_out = {7'b0, Q[1]};
            3'b010: Q_out = {7'b0, Q[2]};
            3'b011: Q_out = {7'b0, Q[3]};
            3'b100: Q_out = {7'b0, Q[4]};
            3'b101: Q_out = {7'b0, Q[5]};
            3'b110: Q_out = {7'b0, Q[6]};
            3'b111: Q_out = {7'b0, Q[7]};
            default: Q_out = 8'b0;
        endcase
    end
    Z = Q_out[0];
end

endmodule