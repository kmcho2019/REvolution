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
    reg [3:0] shift_count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    // Next state logic (combinational)
    wire next_state = (state == IDLE) ? (start ? BUSY : IDLE) :
                     (shift_count == 15) ? IDLE : BUSY;

    // Shift count increment (combinational)
    wire [3:0] next_shift_count = (state == IDLE) ? 4'b0 :
                                (shift_count + 1);

    // Accumulator update logic (combinational)
    wire [31:0] shifted_b = breg << shift_count;
    wire [31:0] next_acc = (state == BUSY && areg[shift_count]) ? 
                          (acc + shifted_b) : acc;

    // Register updates (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            shift_count <= 4'b0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
        end else begin
            state <= next_state;
            shift_count <= next_shift_count;
            
            if (state == IDLE && start) begin
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
            end else begin
                acc <= next_acc;
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == BUSY) && (shift_count == 15);

endmodule