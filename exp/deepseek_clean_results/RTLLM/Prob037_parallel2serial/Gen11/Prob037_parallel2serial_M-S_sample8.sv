module parallel2serial (
    input wire clk,
    input wire rst_n,
    input wire [3:0] d,
    output reg valid_out,
    output reg dout
);

    reg [1:0] cnt;      // 2-bit counter
    reg [3:0] data_reg; // Data storage

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 2'b0;
            data_reg <= 4'b0;
            valid_out <= 1'b0;
            dout <= 1'b0;
        end else begin
            // Update counter
            cnt <= cnt + 1'b1;
            
            // Load new data and set valid when counter wraps
            if (cnt == 2'b11) begin
                data_reg <= d;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
            
            // Select output bit based on counter value
            case (cnt)
                2'b00: dout <= data_reg[3];
                2'b01: dout <= data_reg[2];
                2'b10: dout <= data_reg[1];
                2'b11: dout <= data_reg[0];
            endcase
        end
    end

endmodule