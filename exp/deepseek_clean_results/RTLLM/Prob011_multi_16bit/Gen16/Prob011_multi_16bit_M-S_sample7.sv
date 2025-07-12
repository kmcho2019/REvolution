module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [31:0] shifted_bin;
    
    // Counter control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (!start) begin
            count <= 5'd0;
        end else if (count < 17) begin
            count <= count + 1;
        end
    end

    // Datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            shifted_bin <= 32'b0;
        end else if (start) begin
            if (count == 0) begin
                areg <= ain;
                acc <= 32'b0;
                shifted_bin <= {16'b0, bin};
            end else if (count < 17) begin
                if (areg[count-1]) begin
                    acc <= acc + shifted_bin;
                end
                shifted_bin <= shifted_bin << 1;
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 17);

endmodule