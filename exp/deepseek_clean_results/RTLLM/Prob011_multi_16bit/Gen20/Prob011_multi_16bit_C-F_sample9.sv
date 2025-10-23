module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // Control signals
    reg [4:0] count;
    wire count_en = start && (count < 17);
    wire op_done = (count == 16);  // Done when count reaches 16
    
    // Datapath control
    wire load_phase = (count == 0);
    wire shift_phase = (count > 0) && (count < 17);
    
    // Datapath registers
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] breg;  // Reduced from 32 bits for area optimization
    
    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
        end else if (!start) begin
            count <= 5'd0;
        end else if (count_en) begin
            count <= count + 1;
        end
    end

    // Datapath logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            breg <= 16'b0;
        end else if (start) begin
            if (load_phase) begin
                areg <= ain;
                acc <= 32'b0;
                breg <= bin;
            end else if (shift_phase) begin
                if (areg[count-1]) begin
                    acc <= acc + ({16'b0, breg} << (count-1));
                end
            end
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = op_done;

endmodule