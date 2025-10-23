module parallel2serial (
    input        clk,
    input        rst_n,
    input  [3:0] d,
    output reg   valid_out,
    output      dout
);

    reg [3:0] data;
    reg [1:0] cnt;
    reg       load;  // Signal to indicate when to load new data

    // Output bit is selected from data based on cnt, MSB first
    assign dout = data[3 - cnt];

    // Counter logic: increment cnt or reset to 0 if load is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= 2'b0;
        else if (load)
            cnt <= 2'b0;
        else
            cnt <= cnt + 1'b1;
    end

    // Data loading and valid_out logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data      <= 4'b0;
            valid_out <= 1'b0;
            load      <= 1'b1;  // Start by loading data at first cycle after reset
        end else begin
            if (load) begin
                data      <= d;       // Load parallel input data
                valid_out <= 1'b1;   // Valid output on first bit (MSB)
                load      <= 1'b0;   // Clear load until next cycle count=3
            end else begin
                valid_out <= 1'b0;   // Valid only during load cycle
                if (cnt == 2'd3)
                    load <= 1'b1;    // Load next data after last bit transmitted
            end
        end
    end

endmodule