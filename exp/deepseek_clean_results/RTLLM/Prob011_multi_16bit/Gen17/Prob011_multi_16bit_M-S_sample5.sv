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
    reg [15:0] breg;
    reg [31:0] acc;
    
    // Counter and datapath combined
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
        end else begin
            if (!start) begin
                count <= 5'd0;
                acc <= 32'b0;
            end else if (count < 16) begin
                if (count == 0) begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                end
                if (areg[count]) begin
                    acc <= acc + (breg << count);
                end
                count <= count + 1;
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (count == 16);

endmodule