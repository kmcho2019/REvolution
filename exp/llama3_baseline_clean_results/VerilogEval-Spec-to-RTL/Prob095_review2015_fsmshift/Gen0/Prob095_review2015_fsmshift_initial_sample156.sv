module TopModule(
    input  clk,
    input  reset,
    output reg shift_ena
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam SHIFTING = 2'b01;
reg [1:0] counter;

always @(posedge clk) begin
    if(reset) begin
        state <= SHIFTING;
        counter <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            IDLE: begin
                shift_ena <= 1'b0;
            end
            SHIFTING: begin
                if(counter == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    counter <= counter + 1'b1;
                end
            end
        endcase
    end
end

endmodule