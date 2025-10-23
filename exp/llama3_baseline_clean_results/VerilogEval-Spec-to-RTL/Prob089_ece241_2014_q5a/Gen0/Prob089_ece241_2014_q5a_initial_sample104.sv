module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] nextState;
reg carry;
reg z_reg;

parameter IDLE = 2'b00;
parameter CONVERSION = 2'b01;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= IDLE;
        carry <= 1'b0;
        z_reg <= 1'b0;
    end
    else begin
        state <= nextState;
        if(state == CONVERSION) begin
            z_reg <= ~(x) ^ carry;
            carry <= ~(x) & carry | ~(x) & 1'b1;
        end
        else begin
            carry <= 1'b0;
        end
    end
end

always @(*) begin
    case(state)
        IDLE: begin
            if(areset) begin
                nextState = IDLE;
            end
            else begin
                nextState = CONVERSION;
            end
        end
        CONVERSION: begin
            if(areset) begin
                nextState = IDLE;
            end
            else begin
                nextState = CONVERSION;
            end
        end
        default: begin
            nextState = IDLE;
        end
    endcase
end

assign z = z_reg;

endmodule