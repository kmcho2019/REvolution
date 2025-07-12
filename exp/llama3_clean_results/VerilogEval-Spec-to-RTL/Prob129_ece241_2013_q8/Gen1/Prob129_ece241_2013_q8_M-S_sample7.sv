module TopModule(
    input        clk,
    input        aresetn,
    input        x,
    output reg   z
);

reg [1:0] state;
localparam S0 = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

always @(*) begin
    case (state)
        S0: begin
            if (x) begin
                z = 1'b0;
                state = S1;
            end else begin
                z = 1'b0;
                state = S0;
            end
        end
        S1: begin
            if (~x) begin
                z = 1'b0;
                state = S2;
            end else begin
                z = 1'b0;
                state = S1;
            end
        end
        S2: begin
            if (x) begin
                z = 1'b1;
                state = S1;
            end else begin
                z = 1'b0;
                state = S0;
            end
        end
    endcase
end

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= S0;
        z <= 1'b0;
    end else begin
        reg [1:0] nextState;
        reg nextZ;
        case (state)
            S0: begin
                if (x) begin
                    nextState = S1;
                end else begin
                    nextState = S0;
                end
                nextZ = 1'b0;
            end
            S1: begin
                if (~x) begin
                    nextState = S2;
                end else begin
                    nextState = S1;
                end
                nextZ = 1'b0;
            end
            S2: begin
                if (x) begin
                    nextState = S1;
                end else begin
                    nextState = S0;
                end
                nextZ = x;
            end
        endcase
        state <= nextState;
        z <= nextZ;
    end
end

endmodule