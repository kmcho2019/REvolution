module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] input_num; // register to store the accumulated input bits
reg [31:0] result; // register to store the result
reg [4:0] count; // counter to keep track of the number of input bits received
reg idle; // flag to track whether we are in the idle or running state
reg [31:0] temp; // temporary register to store the flipped bits

always @(posedge clk or posedge areset) begin
    if (areset) begin
        idle <= 1'b1;
        count <= 5'b0;
        input_num <= 32'b0;
        result <= 32'b0;
        z <= 1'b0;
    end else begin
        if (idle) begin
            if (x) begin
                input_num[0] <= x;
                count <= 5'b1;
                idle <= 1'b0;
            end
        end else begin
            input_num[count] <= x;
            count <= count + 1'b1;
            if (areset) begin
                temp <= ~input_num;
                result <= temp + 1'b1;
                z <= result[0];
                idle <= 1'b1;
                count <= 5'b0;
                input_num <= 32'b0;
                result <= 32'b0;
            end else begin
                z <= 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (!idle) begin
        if (count == 5'b100000) begin
            temp <= ~input_num;
            result <= temp + 1'b1;
            z <= result[0];
            idle <= 1'b1;
            count <= 5'b0;
            input_num <= 32'b0;
            result <= 32'b0;
        end
    end
end

endmodule