module TopModule(
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

reg [2:0] state;
reg [2:0] nextState;
reg [2:0] counter;
reg [2:0] nextCounter;

assign disc = (state == 3'd5);
assign flag = (state == 3'd6);
assign err = (state == 3'd7);

always @(*) begin
    case(state)
        3'd0: begin
            if(in) begin
                nextState = 3'd1;
                nextCounter = 3'd1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd1: begin
            if(in) begin
                nextState = 3'd2;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd2: begin
            if(in) begin
                nextState = 3'd3;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd3: begin
            if(in) begin
                nextState = 3'd4;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd4: begin
            if(in) begin
                nextState = 3'd5;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd5: begin
            if(in) begin
                nextState = 3'd6;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd6: begin
            if(in) begin
                nextState = 3'd7;
                nextCounter = counter + 1;
            end else begin
                nextState = 3'd0;
                nextCounter = 3'd0;
            end
        end
        3'd7: begin
            nextState = 3'd7;
            nextCounter = counter + 1;
        end
        default: begin
            nextState = 3'd0;
            nextCounter = 3'd0;
        end
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'd0;
        counter <= 3'd0;
    end else begin
        state <= nextState;
        counter <= nextCounter;
    end
end

endmodule