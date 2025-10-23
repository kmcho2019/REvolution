module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_sync0, a_sync1;
    reg rise_flag, down_flag;

    // Double synchronization of input 'a' to clk domain
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_sync0 <= 1'b0;
            a_sync1 <= 1'b0;
        end else begin
            a_sync0 <= a;
            a_sync1 <= a_sync0;
        end
    end

    // Edge detection and one-cycle pulse generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise_flag <= 1'b0;
            down_flag <= 1'b0;
        end else begin
            rise_flag <= (~a_sync1 & a_sync0) ? 1'b1 : 1'b0;
            down_flag <= (a_sync1 & ~a_sync0) ? 1'b1 : 1'b0;
        end
    end

    // Output rise and down signals driven by registered flags
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            rise <= rise_flag;
            down <= down_flag;
        end
    end

endmodule