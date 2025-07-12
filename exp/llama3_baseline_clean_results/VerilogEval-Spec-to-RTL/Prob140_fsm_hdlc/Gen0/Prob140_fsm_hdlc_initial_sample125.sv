module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [3:0] state;
reg [3:0] nextState;

always @(*) begin
    case (state)
        4'd0: begin
            if (in == 1'b1) begin
                nextState = 4'd1;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd1: begin
            if (in == 1'b1) begin
                nextState = 4'd2;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd2: begin
            if (in == 1'b1) begin
                nextState = 4'd3;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd3: begin
            if (in == 1'b1) begin
                nextState = 4'd4;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd4: begin
            if (in == 1'b1) begin
                nextState = 4'd5;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd5: begin
            if (in == 1'b1) begin
                nextState = 4'd6;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd6: begin
            if (in == 1'b1) begin
                nextState = 4'd7;
            end else begin
                nextState = 4'd0;
            end
        end
        4'd7: begin
            if (in == 1'b1) begin
                nextState = 4'd7;
            end else begin
                nextState = 4'd0;
            end
        end
        default: begin
            nextState = 4'd0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 4'd0;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end else begin
        state <= nextState;
        if (state == 4'd5 && in == 1'b0) begin
            disc <= 1'b1;
        end else if (state == 4'd5) begin
            disc <= 1'b0;
        end
        if (state == 4'd6 && in == 1'b0) begin
            flag <= 1'b1;
        end else if (state == 4'd6) begin
            flag <= 1'b0;
        end
        if (state == 4'd7) begin
            err <= 1'b1;
        end else begin
            err <= 1'b0;
        end
    end
end

endmodule