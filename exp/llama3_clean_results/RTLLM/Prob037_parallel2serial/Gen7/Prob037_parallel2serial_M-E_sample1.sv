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
        state <= 2'b00; // IDLE state
        data <= 4'b0;
        valid <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // IDLE state
                if (d!= 4'b0) begin
                    state <= 2'b01; // LOAD state
                    data <= d;
                    valid <= 1'b1;
                end
            end
            2'b01: begin // LOAD state
                state <= 2'b10; // SHIFT state
            end
            2'b10: begin // SHIFT state
                if (data[0] == 1'b1) begin
                    dout <= data[3];
                    data <= {data[2:0], 1'b0}; // Shift data to the right
                end else begin
                    dout <= data[3];
                    data <= {data[2:0], 1'b0}; // Shift data to the right
                    if (data == 4'b0) begin
                        state <= 2'b11; // DONE state
                        valid <= 1'b0;
                    end
                end
            end
            2'b11: begin // DONE state
                state <= 2'b00; // IDLE state
            end
        endcase
    end
end

assign valid_out = (state == 2'b10)? 1'b1 : 1'b0;

endmodule