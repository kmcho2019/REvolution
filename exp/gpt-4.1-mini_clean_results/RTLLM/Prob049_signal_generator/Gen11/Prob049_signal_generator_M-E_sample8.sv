module signal_generator (
    input            clk,
    input            rst_n,
    output reg [4:0] wave
);

    reg [5:0] count;  // 6 bits to hold values 0 to 31 inclusive
    reg        dir;   // direction: 0 = increment, 1 = decrement

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            count <= 6'd0;
            dir   <= 1'b0;
            wave  <= 5'd0;
        end else begin
            // Update counter based on direction
            if (dir == 1'b0) begin
                // increment direction
                if (count == 6'd31) begin
                    dir <= 1'b1;    // switch to decrement
                    count <= count - 6'd1;
                end else begin
                    count <= count + 6'd1;
                end
            end else begin
                // decrement direction
                if (count == 6'd0) begin
                    dir <= 1'b0;    // switch to increment
                    count <= count + 6'd1;
                end else begin
                    count <= count - 6'd1;
                end
            end

            wave <= count[4:0];
        end
    end

endmodule