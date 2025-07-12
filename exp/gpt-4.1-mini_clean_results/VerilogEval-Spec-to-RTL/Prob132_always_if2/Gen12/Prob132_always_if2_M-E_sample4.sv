module TopModule (
    input             cpu_overheated,
    output reg        shut_off_computer,
    input             arrived,
    input             gas_tank_empty,
    output reg        keep_driving
);

    wire shut_off_wire;
    wire keep_drive_wire;

    // Combinational logic via continuous assignment
    assign shut_off_wire = cpu_overheated;
    assign keep_drive_wire = (~arrived) & (~gas_tank_empty);

    // Assign outputs directly from wires continuously (behaves as combinational)
    always @(*) begin
        shut_off_computer = shut_off_wire;
        keep_driving = keep_drive_wire;
    end

endmodule