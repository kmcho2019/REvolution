module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Need 5 bits to count to 16
    reg [15:0] breg;
    reg [31:0] accumulator;

    // Done is high when count reaches 16
    assign done = (count == 5'd16);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            accumulator <= 32'd0;
            yout <= 32'd0;
            breg <= 16'd0;
        end else begin
            if (start) begin
                if (count == 5'd0) begin
                    // Load operands and initialize
                    accumulator <= 32'd0;
                    breg <= bin;
                    count <= count + 1;
                end
                else if (count <= 5'd16) begin
                    // Shift and accumulate
                    if (ain[count-1]) begin
                        accumulator <= accumulator + (breg << (count-1));
                    end
                    count <= count + 1;
                end
            end else begin
                count <= 5'd0;
            end

            // Capture result when done
            if (count == 5'd16) begin
                yout <= accumulator;
            end
        end
    end

endmodule