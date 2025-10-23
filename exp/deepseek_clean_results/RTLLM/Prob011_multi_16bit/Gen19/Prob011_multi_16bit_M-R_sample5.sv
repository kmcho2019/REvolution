module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [4:0] count;  // Now properly sized for 16 iterations
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;

    // Next state logic (combinational)
    wire next_state_IDLE = !rst_n || (state == DONE && !start);
    wire next_state_CALC = (state == IDLE && start) || 
                         (state == CALC && count < 15);
    wire next_state_DONE = (state == CALC && count == 15);

    // State transition (sequential)
    always @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            case (1'b1)  // Synthesis will optimize this
                next_state_IDLE: begin
                    state <= IDLE;
                    count <= 5'd0;
                    accumulator <= 32'd0;
                end
                next_state_CALC: begin
                    state <= CALC;
                    if (state == IDLE) begin
                        areg <= ain;
                        breg <= bin;
                        count <= 5'd0;
                    end else begin
                        if (areg[count]) begin
                            accumulator <= accumulator + (breg << count);
                        end
                        count <= count + 1;
                    end
                end
                next_state_DONE: begin
                    state <= DONE;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = (state == DONE) ? accumulator : 32'd0;
    assign done = (state == DONE);

endmodule