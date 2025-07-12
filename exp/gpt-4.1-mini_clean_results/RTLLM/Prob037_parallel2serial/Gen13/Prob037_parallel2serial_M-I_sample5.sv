module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    input        load_en,    // Enable loading new parallel data
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            if (load_en) begin
                data      <= d;      // Load new data only when load_en is asserted
                cnt       <= 2'b00;
                valid_out <= 1'b1;  // Valid asserted at MSB output of new data
            end else if (cnt != 2'd3) begin
                cnt       <= cnt + 1'b1;
                valid_out <= 1'b0;
            end else begin
                cnt       <= 2'b00;  // Reset counter after last bit output
                valid_out <= 1'b1;  // Assert valid for new data output cycle
            end
        end
    end

    // Output bit indexed from stored data register, MSB to LSB
    assign dout = data[3 - cnt];

endmodule