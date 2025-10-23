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
    reg done_r;

    // Counter control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 0;
        end else if (start) begin
            if (count < 16) begin
                count <= count + 1;
            end
        end else begin
            count <= 0;
        end
    end

    // Datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 0;
            acc <= 0;
            done_r <= 0;
        end else if (start) begin
            if (count == 0) begin
                areg <= ain;
                acc <= 0;
                done_r <= 0;
            end else if (count <= 16) begin
                if (areg[count-1]) begin
                    acc <= acc + (bin << (count-1));
                end
                done_r <= (count == 16);
            end
        end else begin
            done_r <= 0;
        end
    end

    assign yout = acc;
    assign done = done_r;

endmodule