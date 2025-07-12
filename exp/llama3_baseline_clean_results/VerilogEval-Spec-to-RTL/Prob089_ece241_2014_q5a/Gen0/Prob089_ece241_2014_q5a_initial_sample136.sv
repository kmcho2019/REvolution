module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] num; // assuming 32 bits maximum, adjust according to requirement
reg [31:0] result;
reg [4:0] count; // counter to track the number of bits processed
reg compute;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        num <= 0;
        result <= 0;
        count <= 0;
        compute <= 0;
        z <= 0;
    end else if (compute) begin
        if (count == 0) begin
            num[0] <= x;
            count <= count + 1;
        end else if (count < 32) begin
            num[count] <= x;
            count <= count + 1;
        end else begin
            // Start outputting the 2's complement
            result <= ~(num) + 1;
            count <= 0;
            compute <= 0;
        end
    end else begin
        if (x == 1'b1) begin
            num[0] <= x;
            count <= count + 1;
            compute <= 1;
        end
    end
end

always @(posedge clk) begin
    if (~compute && ~areset) begin
        if (count == 0) begin
            z <= 0;
        end else if (count > 0 && count <= 32) begin
            z <= num[count-1];
            count <= count - 1;
        end else if (count == 0 && result != 0) begin
            z <= result[0];
            result <= result >> 1;
        end
    end else if (compute) begin
        z <= 0;
    end
end

endmodule