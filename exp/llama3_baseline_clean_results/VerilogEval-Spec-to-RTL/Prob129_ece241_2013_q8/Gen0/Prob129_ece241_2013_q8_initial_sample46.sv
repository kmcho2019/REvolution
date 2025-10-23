module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

reg [1:0] state, next_state;
parameter IDLE = 2'b00, GOT_1 = 2'b01, GOT_10 = 2'b10;

always @(*) begin
    case(state)
        IDLE: begin
            if(x)
                next_state = GOT_1;
            else
                next_state = IDLE;
        end
        GOT_1: begin
            if(x)
                next_state = GOT_1;
            else
                next_state = GOT_10;
        end
        GOT_10: begin
            if(x)
                next_state = GOT_1;
            else
                next_state = IDLE;
        end
        default:
            next_state = IDLE;
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if(!aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        IDLE: z = 0;
        GOT_1: z = 0;
        GOT_10: z = x;
        default: z = 0;
    endcase
end

endmodule