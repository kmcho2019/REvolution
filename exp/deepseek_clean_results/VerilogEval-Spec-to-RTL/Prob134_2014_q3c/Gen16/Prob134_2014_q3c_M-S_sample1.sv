module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    always @(*) begin
        case (y)
            3'b000: {Y0, z} = x ? {1'b1, 1'b0} : {1'b0, 1'b0};
            3'b001: {Y0, z} = x ? {1'b0, 1'b0} : {1'b1, 1'b0};
            3'b010: {Y0, z} = x ? {1'b1, 1'b0} : {1'b0, 1'b0};
            3'b011: {Y0, z} = x ? {1'b0, 1'b1} : {1'b1, 1'b1};
            3'b100: {Y0, z} = x ? {1'b0, 1'b1} : {1'b1, 1'b1};
            default: {Y0, z} = {1'b0, 1'b0};
        endcase
    end

endmodule