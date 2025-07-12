module parallel2serial (
    input clk,
    input rst_n,
    input [3:0] d,
    output valid_out,
    output dout
);

reg [3:0] data;
reg [1:0] state;
reg valid;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data <= 4'b0;
        state <= 2'b00;
        valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // Load data and output MSB
                data <= d;
                state <= 2'b01;
                valid <= 1'b1;
            end
            2'b01: begin // Output second bit
                data <= {data[2:0], data[3]};
                state <= 2'b10;
                valid <= 1'b1;
            end
            2'b10: begin // Output third bit
                data <= {data[2:0], data[3]};
                state <= 2'b11;
                valid <= 1'b1;
            end
            2'b11: begin // Output LSB and reset
                data <= {data[2:0], data[3]};
                state <= 2'b00;
                valid <= 1'b1;
            end
        endcase
    end
end

assign valid_out = valid;
assign dout = data[3];

endmodule