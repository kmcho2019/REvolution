module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    parameter CNT_WIDTH = 2;
    reg [CNT_WIDTH-1:0] cnt;
    reg [3:0] data;

    // Combinational outputs
    assign valid_out = (cnt == {CNT_WIDTH{1'b1}}); // Valid when counter is max value
    assign dout = data[3]; // Always output MSB

    // Counter and data loading
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= {CNT_WIDTH{1'b0}};
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // Data register handling
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data <= 4'b0;
        end else if (valid_out) begin
            data <= d; // Load new parallel data
        end else begin
            data <= {data[2:0], 1'b0}; // Shift left
        end
    end

endmodule