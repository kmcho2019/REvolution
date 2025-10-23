module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state;
reg [1:0] count;

always @(posedge clk) begin
    if(reset) begin
        state <= 0; // IDLE state
        count <= 0;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            2'b00: begin // IDLE state
                shift_ena <= 1'b0;
                if(~reset) begin
                    state <= 2'b01; // SHIFTING state
                    count <= 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            2'b01: begin // SHIFTING state
                count <= count + 1'b1;
                if(count == 4'b100) begin
                    state <= 2'b00; // IDLE state
                    shift_ena <= 1'b0;
                end else begin
                    shift_ena <= 1'b1;
                end
            end
            default: begin
                state <= 2'b00; // IDLE state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule