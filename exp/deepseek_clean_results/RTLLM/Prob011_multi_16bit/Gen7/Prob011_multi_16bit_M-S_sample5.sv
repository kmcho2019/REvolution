module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;  // Counts 0-16 (5 bits)
    reg [15:0] areg;
    reg [31:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            acc <= 32'b0;
        end else if (start && count == 0) begin
            // Load operands and initialize
            areg <= ain;
            acc <= 32'b0;
            count <= count + 1;
        end else if (count > 0 && count < 17) begin
            // Shift and accumulate phase
            if (areg[count-1]) begin
                acc <= acc + (bin << (count-1));
            end
            count <= count + 1;
        end else begin
            // Idle state
            count <= 5'd0;
        end
    end

    assign yout = acc;
    assign done = (count == 17);

endmodule