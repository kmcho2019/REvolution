module TopModule(
    input x,
    input y,
    output reg z
);
    reg [1:0] state; // 2 states: S0 (0) and S1 (1)
    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;

    always @(*) begin
        case(state)
            S0: begin
                if(x == 0 && y == 0) begin
                    z = 1'b1;
                end else if (x == 1 && y == 0) begin
                    state = S2;
                    z = 1'b0;
                end else if (x == 0 && y == 1) begin
                    state = S2;
                    z = 1'b0;
                end else if (x == 1 && y == 1) begin
                    state = S0;
                    z = 1'b1;
                end
            end
            S1: begin
                if(x == 1 && y == 1) begin
                    state = S0;
                    z = 1'b1;
                end else if (x == 0 && y == 0) begin
                    state = S0;
                    z = 1'b1;
                end else begin
                    state = S2;
                    z = 1'b0;
                end
            end
            S2: begin
                if(x == 1 && y == 1) begin
                    state = S0;
                    z = 1'b1;
                end else if (x == 0 && y == 0) begin
                    state = S0;
                    z = 1'b1;
                end else begin
                    state = S2;
                    z = 1'b0;
                end
            end
            default: begin
                state = S0;
                z = 1'b1;
            end
        endcase
    end

    always @(posedge x or posedge y) begin
        if (x == 0 && y == 0) begin
            state = S0;
        end else if (x == 1 && y == 1) begin
            state = S0;
        end else begin
            state = S2;
        end
    end
endmodule