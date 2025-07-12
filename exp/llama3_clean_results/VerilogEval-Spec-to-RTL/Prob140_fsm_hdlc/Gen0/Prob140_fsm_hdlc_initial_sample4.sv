module TopModule(
    input           clk,
    input           reset,
    input           in,
    output          disc,
    output          flag,
    output          err
);

reg [2:0] state; // 0: idle, 1: ones, 2: flag, 3: discard, 4: error
reg [2:0] nextState;
reg disc_reg;
reg flag_reg;
reg err_reg;

// State encoding
parameter IDLE = 3'b000;
parameter ONES = 3'b001;
parameter FLAG = 3'b010;
parameter DISCARD = 3'b011;
parameter ERROR = 3'b100;

always @(*) begin
    case(state)
        IDLE: begin
            if(in) begin
                nextState = ONES;
            end else begin
                nextState = IDLE;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ONES: begin
            if(in) begin
                nextState = ONES;
            end else begin
                nextState = IDLE;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        FLAG: begin
            if(in) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b1;
            err_reg = 1'b0;
        end
        DISCARD: begin
            nextState = IDLE;
            disc_reg = 1'b1;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        ERROR: begin
            if(in) begin
                nextState = ERROR;
            end else begin
                nextState = IDLE;
            end
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b1;
        end
        default: begin
            nextState = IDLE;
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= IDLE;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg;
    end
end

always @(state) begin
    case(state)
        IDLE: begin
            if(in) begin
                state = ONES;
            end
        end
        ONES: begin
            if(in) begin
                // checking for 5 ones, need to discard a bit
                if(state == ONES) begin
                    state = DISCARD;
                end else begin
                    state = FLAG;
                end
            end
        end
        default: begin
            state = state;
        end
    endcase
end

endmodule