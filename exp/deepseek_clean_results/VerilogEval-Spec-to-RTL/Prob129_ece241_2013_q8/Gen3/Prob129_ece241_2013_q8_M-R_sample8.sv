module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // State encoding using localparam
    localparam [1:0] IDLE  = 2'b00;
    localparam [1:0] GOT1  = 2'b01;
    localparam [1:0] GOT10 = 2'b10;

    reg [1:0] state;

    // Combinational output logic
    assign z = (state == GOT10) & x;

    // State transition logic
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

endmodule