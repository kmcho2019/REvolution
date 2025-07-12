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
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;
    reg [4:0] count;  // Now properly sized for 16 iterations (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    wire [31:0] shifted_b;

    // Shifted version of multiplier (combinational)
    assign shifted_b = {16'b0, breg} << count;

    // Next state logic (combinational)
    wire next_state;
    assign next_state = (!rst_n) ? IDLE :
                       (state == IDLE) ? (start ? BUSY : IDLE) :
                       (state == BUSY) ? ((count == 15) ? IDLE : BUSY) : IDLE;

    // State transition and data processing (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            state <= next_state;
            
            if (state == IDLE) begin
                count <= 5'd0;
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    accumulator <= 32'd0;
                end
            end
            else if (state == BUSY) begin
                if (areg[count]) begin
                    accumulator <= accumulator + shifted_b;
                end
                count <= count + 1;
            end
        end
    end

    // Output assignments (combinational)
    assign yout = (state == IDLE && count == 16) ? accumulator : 32'd0;
    assign done = (state == IDLE && count == 16);

endmodule