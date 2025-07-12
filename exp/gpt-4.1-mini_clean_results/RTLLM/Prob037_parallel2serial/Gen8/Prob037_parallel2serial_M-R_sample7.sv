module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output       dout,
    output       valid_out
);

    reg [3:0] data;
    reg [1:0] cnt;

    // Counter: counts from 0 to 3, synchronous reset active low
    always @(posedge clk) begin
        if (!rst_n)
            cnt <= 2'd3;  // Initialize to 3 so data loads at first clock after reset
        else
            cnt <= (cnt == 2'd3) ? 2'd0 : cnt + 1'b1;
    end

    // Data register with rotate-left logic or load new data when cnt==3
    always @(posedge clk) begin
        if (!rst_n)
            data <= 4'b0;
        else if (cnt == 2'd3)
            data <= d;  // Load new parallel data at cnt=3
        else
            data <= {data[2:0], data[3]}; // Rotate left
    end

    // Output the MSB of data
    assign dout = data[3];

    // valid_out is high only at cnt==3, indicating new data loaded and MSB output valid
    assign valid_out = (cnt == 2'd3);

endmodule