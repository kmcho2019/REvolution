module TopModule(
    input [7:0] code,
    output reg [3:0] out,
    output reg valid
);

always @(*) begin
    valid = 0;
    out = 0;
    if (code == 8'h45) {valid, out} = 5'b10000;
    else if (code == 8'h16) {valid, out} = 5'b10001;
    else if (code == 8'h1e) {valid, out} = 5'b10010;
    else if (code == 8'h26) {valid, out} = 5'b10011;
    else if (code == 8'h25) {valid, out} = 5'b10100;
    else if (code == 8'h2e) {valid, out} = 5'b10101;
    else if (code == 8'h36) {valid, out} = 5'b10110;
    else if (code == 8'h3d) {valid, out} = 5'b10111;
    else if (code == 8'h3e) {valid, out} = 5'b11000;
    else if (code == 8'h46) {valid, out} = 5'b11001;
end

endmodule