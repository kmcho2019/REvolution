module TopModule(
    input         clk,
    input         reset,
    output        shift_ena
);

reg [1:0] state;
localparam IDLE = 2'b00;
localparam RESET = 2'b01;
localparam COUNT = 2'b10;
reg [1:0] count;

always @(posedge clk) begin
    if(reset) begin
        state <= RESET;
        count <= 2'b00;
        shift_ena <= 1'b1;
    end else begin
        case(state)
            IDLE: begin
                if(reset) begin
                    state <= RESET;
                    count <= 2'b00;
                    shift_ena <= 1'b1;
                end else begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end
            end
            RESET: begin
                state <= COUNT;
                count <= 2'b01;
                shift_ena <= 1'b1;
            end
            COUNT: begin
                if(count == 2'b11) begin
                    state <= IDLE;
                    shift_ena <= 1'b0;
                end else begin
                    state <= COUNT;
                    count <= count + 1'b1;
                    shift_ena <= 1'b1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule