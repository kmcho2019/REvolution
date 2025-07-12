module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    // State encoding using localparams for minimal area and clarity
    localparam [1:0]
        S_IDLE = 2'b00,  // no bits matched
        S_1    = 2'b01,  // matched '1'
        S_10   = 2'b10;  // matched "10"

    reg [1:0] state;

    // Sequential logic with asynchronous negative edge reset and direct next-state assignment
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else begin
            case (state)
                S_IDLE: state <= x ? S_1 : S_IDLE;
                S_1:    state <= x ? S_1 : S_10;
                S_10:   state <= x ? S_1 : S_IDLE;
                default: state <= S_IDLE; // safe default
            endcase
        end
    end

    // Mealy output logic (combinational)
    always @(*) begin
        // Assert z=1 if current state is S_10 and input x is 1 (completing "101" sequence)
        z = (state == S_10) && (x == 1'b1);
    end

endmodule