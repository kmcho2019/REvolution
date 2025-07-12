module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_d1, a_d2;
    reg rise_reg, down_reg;

    // Double-register input 'a' for stable edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_d1 <= 1'b0;
            a_d2 <= 1'b0;
        end else begin
            a_d1 <= a;
            a_d2 <= a_d1;
        end
    end

    // Edge detection and output pulse generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rise_reg <= 1'b0;
            down_reg <= 1'b0;
            rise <= 1'b0;
            down <= 1'b0;
        end else begin
            // Detect rising edge when a_d2=0 and a_d1=1
            if ((a_d2 == 1'b0) && (a_d1 == 1'b1))
                rise_reg <= 1'b1;
            else
                rise_reg <= 1'b0;

            // Detect falling edge when a_d2=1 and a_d1=0
            if ((a_d2 == 1'b1) && (a_d1 == 1'b0))
                down_reg <= 1'b1;
            else
                down_reg <= 1'b0;

            // Output one-cycle pulse after edge detection
            rise <= rise_reg;
            down <= down_reg;
        end
    end

endmodule