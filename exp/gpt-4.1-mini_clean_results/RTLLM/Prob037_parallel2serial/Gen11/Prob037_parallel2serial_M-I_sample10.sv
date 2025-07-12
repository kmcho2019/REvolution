module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [1:0] cnt;
    reg [3:0] data;
    wire      load_data;
    wire      count_en;

    // Load new data when cnt is 0 (start of serialization)
    assign load_data = (cnt == 2'd0);
    // Enable counting every cycle (always enabled to maintain continuous serialization)
    assign count_en = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt       <= 2'b00;
            data      <= 4'b0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= (cnt == 2'd0); // valid_out high only on first bit output
            if (load_data)
                data <= d;             // load input data into internal register

            if (count_en) begin
                if (cnt == 2'd3)
                    cnt <= 2'b00;      // reset counter after 4 bits output
                else
                    cnt <= cnt + 1'b1;
            end
        end
    end

    // Output MSB first from registered data, indexing by cnt
    assign dout = data[3 - cnt];

endmodule