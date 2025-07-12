module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] input_num = 0;  // register to store input number
reg [31:0] complement = 0;  // register to store 2's complement
reg [4:0] count = 0;  // counter to track bit position
reg first_one = 0;  // flag to track first '1' in input stream

always @(posedge clk or posedge areset) begin
    if (areset) begin
        input_num <= 0;
        complement <= 0;
        count <= 0;
        first_one <= 0;
        z <= 0;
    end else begin
        if (count == 0) begin
            input_num <= x;
            complement <= ~x + 1;
            count <= 1;
            first_one <= x;
            z <= complement[0];
        end else begin
            input_num <= {input_num[30:0], x};
            if (first_one) begin
                complement <= {complement[30:0], ~x + 1};
            end else begin
                if (x) begin
                    first_one <= 1;
                    complement <= {complement[30:0], ~x + 1};
                end else begin
                    complement <= {complement[30:0], x};
                end
            end
            count <= count + 1;
            z <= complement[count-1];
        end
    end
end

endmodule