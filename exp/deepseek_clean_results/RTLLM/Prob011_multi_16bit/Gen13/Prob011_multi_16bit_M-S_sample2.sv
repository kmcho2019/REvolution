module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] count;  // Need 5 bits to count to 16 (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd16;  // Initialize to done state
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= 5'd0;
                done <= 1'b0;
            end else if (count < 16) begin
                // Perform shift-and-add
                if (areg[count]) begin
                    acc <= acc + (breg << count);
                end
                count <= count + 1;
                done <= (count == 15);  // Assert done on last cycle
            end else begin
                // Multiplication complete
                done <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(*) begin
        yout = acc;
    end

endmodule