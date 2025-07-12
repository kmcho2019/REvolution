module TopModule(
    input clk,
    input reset,
    output reg shift_ena
);

reg [1:0] state; // 0: idle, 1: shifting, 2: shifting (counting), 3: shifting (counting)
reg [1:0] count;

always @(posedge clk) begin
    if(reset) begin
        shift_ena <= 1'b1;
        state <= 1;
        count <= 2'd0;
    end else begin
        case(state)
            1: begin // shifting state
                shift_ena <= 1'b1;
                if(count == 2'd3) begin
                    state <= 0; // idle state
                    count <= 2'd0;
                end else begin
                    count <= count + 1;
                end
            end
            0: begin // idle state
                shift_ena <= 1'b0;
            end
        endcase
    end
end

endmodule