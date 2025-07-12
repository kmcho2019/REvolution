module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    reg [1:0] state; // 2-bit state variable to represent 4 states
    reg [1:0] nextState; // next state variable

    // state encoding
    localparam IDLE  = 2'b00;
    localparam SEQ1  = 2'b01;
    localparam SEQ2  = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (~aresetn) begin
            state <= IDLE;
        end else begin
            state <= nextState;
        end
    end

    always @(*) begin
        case(state)
            IDLE: begin
                if (x) begin
                    nextState = SEQ1;
                end else begin
                    nextState = IDLE;
                end
            end
            SEQ1: begin
                if (~x) begin
                    nextState = SEQ2;
                end else begin
                    nextState = SEQ1;
                end
            end
            SEQ2: begin
                if (x) begin
                    nextState = SEQ1;
                end else begin
                    nextState = IDLE;
                end
            end
            default: begin
                nextState = IDLE;
            end
        endcase
    end

    assign z = (state == SEQ2 && x);

endmodule