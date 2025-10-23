module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output wire valid_out,
    output wire dout
);

    reg [1:0] cnt;          // Binary counter (0-3)
    reg [3:0] data_reg;
    reg load_en;            // Clock gating control
    
    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            load_en <= 1'b0;
        end else begin
            if (cnt == 2'b11) begin
                cnt <= 2'b0;
                load_en <= 1'b1;    // Enable load next cycle
            end else begin
                cnt <= cnt + 1'b1;
                load_en <= 1'b0;
            end
        end
    end

    // Clock-gated data register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 4'b0;
        end else if (load_en) begin
            data_reg <= d;
        end else begin
            data_reg <= {data_reg[2:0], 1'b0};  // Shift left
        end
    end

    assign dout = data_reg[3];      // MSB is output
    assign valid_out = (cnt == 2'b0) & !load_en;  // Valid first cycle after load

endmodule