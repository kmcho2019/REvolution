module TopModule(clk, reset, x, z);
    input clk, reset, x;
    output z;
    reg [2:0] currentState, nextState;
    wire zOut;

    // Combinational logic for next state and output
    always @(*)
    begin
        case(currentState)
            3'b000: begin
                if (!x) begin
                    nextState = 3'b000;
                end else begin
                    nextState = 3'b001;
                end
                zOut = 1'b0;
            end
            3'b001: begin
                if (!x) begin
                    nextState = 3'b001;
                end else begin
                    nextState = 3'b100;
                end
                zOut = 1'b0;
            end
            3'b010: begin
                if (!x) begin
                    nextState = 3'b010;
                end else begin
                    nextState = 3'b001;
                end
                zOut = 1'b0;
            end
            3'b011: begin
                if (!x) begin
                    nextState = 3'b001;
                end else begin
                    nextState = 3'b010;
                end
                zOut = 1'b1;
            end
            3'b100: begin
                if (!x) begin
                    nextState = 3'b011;
                end else begin
                    nextState = 3'b100;
                end
                zOut = 1'b1;
            end
            default: begin
                nextState = 3'b000; // Default next state if current state is not recognized
                zOut = 1'b0;
            end
        endcase
    end

    // Sequential logic for state update
    always @(posedge clk)
    begin
        if (reset) begin
            currentState <= 3'b000;
        end else begin
            currentState <= nextState;
        end
    end

    assign z = zOut;

endmodule