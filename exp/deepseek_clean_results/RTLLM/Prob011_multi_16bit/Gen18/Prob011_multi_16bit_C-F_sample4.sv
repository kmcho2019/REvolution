module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 16);
    wire count_rst = !rst_n || !start;
    wire shift_load = (count == 0);
    wire shift_en = (count > 0) && (count <= 16);

    // Datapath registers
    reg [15:0] areg;
    reg [31:0] shifted_bin;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            shifted_bin <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else if (count_rst) begin
            count <= 5'd0;
            done <= 1'b0;
        end else if (start) begin
            if (shift_load) begin
                // Initialize registers
                areg <= ain;
                shifted_bin <= {16'b0, bin};
                yout <= 32'b0;
            end else if (shift_en) begin
                // Shift and accumulate
                if (areg[count-1])
                    yout <= yout + shifted_bin;
                
                // Shift multiplier left
                shifted_bin <= shifted_bin << 1;
                
                // Update counter
                count <= count + 1;
            end
            
            // Done signal generation
            done <= (count == 16);
        end
    end

endmodule