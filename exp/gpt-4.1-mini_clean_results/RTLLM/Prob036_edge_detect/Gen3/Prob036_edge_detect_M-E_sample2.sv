module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_reg;

    // Register input 'a'
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 1'b0;
        end else begin
            a_reg <= a;
        end
    end

    // Edge detection and pulse generation logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge: a changed from 0 to 1
            if (~a_reg && a)
                rise <= 1'b1;
            else
                rise <= 1'b0;

            // Detect falling edge: a changed from 1 to 0
            if (a_reg && ~a)
                down <= 1'b1;
            else
                down <= 1'b0;
        end
    end

endmodule