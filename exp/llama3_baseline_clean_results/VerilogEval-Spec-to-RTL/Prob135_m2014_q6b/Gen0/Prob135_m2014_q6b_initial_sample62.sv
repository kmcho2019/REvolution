module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

assign Y1 = y[1];

always @(y or w)
    case (y)
        3'b000: begin // A
            if (~w) begin
                // go to B
                Y1 = 1'b1;
            end else begin
                // stay in A
                Y1 = 1'b0;
            end
        end
        3'b001: begin // B
            if (~w) begin
                // go to C
                Y1 = 1'b0;
            end else begin
                // go to D
                Y1 = 1'b1;
            end
        end
        3'b010: begin // C
            if (~w) begin
                // go to E
                Y1 = 1'b0;
            end else begin
                // go to D
                Y1 = 1'b1;
            end
        end
        3'b011: begin // D
            if (~w) begin
                // go to F
                Y1 = 1'b0;
            end else begin
                // go to A
                Y1 = 1'b0;
            end
        end
        3'b100: begin // E
            if (w) begin
                // stay in E
                Y1 = 1'b1;
            end else begin
                // go to D
                Y1 = 1'b1;
            end
        end
        3'b101: begin // F
            if (w) begin
                // go to C
                Y1 = 1'b0;
            end else begin
                // go to D
                Y1 = 1'b1;
            end
        end
        default: begin
            Y1 = 1'b0;
        end
    endcase

endmodule