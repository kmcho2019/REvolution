module TopModule (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg disc_reg;
reg flag_reg;
reg err_reg;

// State encoding
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;
localparam S5 = 3'b101;
localparam DISC = 3'b110;
localparam FLAG = 3'b111;

always @(*) begin
    case (state)
        S0: begin
            if (in) begin
                nextState = S1;
            end else begin
                nextState = S0;
            end
        end
        S1: begin
            if (in) begin
                nextState = S2;
            end else begin
                nextState = S0;
            end
        end
        S2: begin
            if (in) begin
                nextState = S3;
            end else begin
                nextState = S0;
            end
        end
        S3: begin
            if (in) begin
                nextState = S4;
            end else begin
                nextState = S0;
            end
        end
        S4: begin
            if (in) begin
                nextState = S5;
            end else begin
                nextState = S0;
            end
        end
        S5: begin
            if (in) begin
                nextState = DISC;
            end else begin
                nextState = S0;
            end
        end
        DISC: begin
            if (in) begin
                nextState = FLAG;
            end else begin
                nextState = S0;
            end
        end
        FLAG: begin
            if (in) begin
                nextState = FLAG;
            end else begin
                nextState = S0;
            end
        end
        default: begin
            nextState = S0;
        end
    endcase

    case (state)
        S5: begin
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        DISC: begin
            disc_reg = 1'b1;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
        FLAG: begin
            disc_reg = 1'b0;
            flag_reg = 1'b1;
            err_reg = 1'b1;
        end
        default: begin
            disc_reg = 1'b0;
            flag_reg = 1'b0;
            err_reg = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        disc <= disc_reg;
        flag <= flag_reg;
        err <= err_reg && !in; // err is set high only if there are 7 or more consecutive 1s
    end
end

endmodule