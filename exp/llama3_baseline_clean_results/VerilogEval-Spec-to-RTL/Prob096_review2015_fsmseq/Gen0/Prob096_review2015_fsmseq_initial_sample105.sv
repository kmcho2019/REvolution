module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

reg [1:0] current_state;
parameter IDLE = 2'b00;
parameter FOUND_11 = 2'b01;
parameter FOUND_110 = 2'b10;
parameter FOUND_SEQ = 2'b11;

always @(posedge clk) begin
    if(reset) begin
        current_state <= IDLE;
        start_shifting <= 0;
    end else begin
        case(current_state)
            IDLE: begin
                if(data) begin
                    current_state <= FOUND_11;
                end else begin
                    current_state <= IDLE;
                end
            end
            FOUND_11: begin
                if(data) begin
                    current_state <= FOUND_110;
                end else begin
                    current_state <= IDLE;
                end
            end
            FOUND_110: begin
                if(!data) begin
                    current_state <= FOUND_SEQ;
                end else begin
                    current_state <= FOUND_11;
                end
            end
            FOUND_SEQ: begin
                current_state <= FOUND_SEQ;
                start_shifting <= 1;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

endmodule