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

always @(*) begin
    case (state)
        3'b000: begin // State 0
            if (in) begin
                nextState = 3'b001; // Move to State 1
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Stay in State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        3'b001: begin // State 1
            if (in) begin
                nextState = 3'b010; // Move to State 2
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        3'b010: begin // State 2
            if (in) begin
                nextState = 3'b011; // Move to State 3
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        3'b011: begin // State 3
            if (in) begin
                nextState = 3'b100; // Move to State 4
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        3'b100: begin // State 4
            if (in) begin
                nextState = 3'b101; // Move to State 5
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        3'b101: begin // State 5
            if (in) begin
                nextState = 3'b110; // Move to State 6
                disc = 1'b1; // Set disc
                flag = 1'b0;
                err = 1'b0;
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b1; // Set flag
                err = 1'b0;
            end
        end
        3'b110: begin // State 6
            if (in) begin
                nextState = 3'b110; // Stay in State 6
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b1; // Set error
            end
            else begin
                nextState = 3'b000; // Move back to State 0
                disc = 1'b0;
                flag = 1'b0;
                err = 1'b0;
            end
        end
        default: begin
            nextState = 3'b000; // Move back to State 0
            disc = 1'b0;
            flag = 1'b0;
            err = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        state <= 3'b000;
        disc <= 1'b0;
        flag <= 1'b0;
        err <= 1'b0;
    end
    else begin
        state <= nextState;
    end
end

endmodule